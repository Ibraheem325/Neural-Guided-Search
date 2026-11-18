(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	infrared3 - mode
	infrared1 - mode
	thermograph2 - mode
	spectrograph4 - mode
	spectrograph0 - mode
	GroundStation4 - direction
	GroundStation8 - direction
	Star3 - direction
	Star9 - direction
	GroundStation0 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Star17 - direction
	Planet18 - direction
	Star19 - direction
	Planet20 - direction
	Phenomenon21 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star3)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet11)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared1)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon16)
	(supports instrument3 spectrograph4)
	(supports instrument3 infrared1)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star6)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon21)
	(supports instrument4 infrared1)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 Star5)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star6)
	(supports instrument5 spectrograph0)
	(supports instrument5 infrared3)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 Star7)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation8)
	(supports instrument6 spectrograph4)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 GroundStation1)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star17)
)
(:goal (and
	(pointing satellite1 Star9)
	(pointing satellite2 Phenomenon12)
	(pointing satellite3 Star3)
	(pointing satellite5 Star7)
	(have_image Phenomenon10 thermograph2)
	(have_image Planet11 infrared1)
	(have_image Phenomenon12 infrared1)
	(have_image Phenomenon13 infrared3)
	(have_image Phenomenon14 spectrograph4)
	(have_image Planet15 infrared1)
	(have_image Phenomenon16 infrared1)
	(have_image Star17 spectrograph0)
	(have_image Planet18 spectrograph0)
	(have_image Star19 infrared3)
	(have_image Planet20 spectrograph4)
	(have_image Phenomenon21 spectrograph0)
))

)
