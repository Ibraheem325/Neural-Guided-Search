(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	infrared5 - mode
	spectrograph2 - mode
	spectrograph0 - mode
	spectrograph1 - mode
	thermograph4 - mode
	infrared3 - mode
	Star7 - direction
	GroundStation0 - direction
	Star5 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	GroundStation3 - direction
	Star8 - direction
	GroundStation4 - direction
	GroundStation11 - direction
	Star6 - direction
	Planet12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph2)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation4)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
	(supports instrument3 spectrograph2)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation10)
	(supports instrument4 infrared5)
	(supports instrument4 thermograph4)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 GroundStation9)
	(supports instrument5 spectrograph2)
	(supports instrument5 thermograph4)
	(supports instrument5 infrared5)
	(calibration_target instrument5 Star6)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 Star8)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star8)
)
(:goal (and
	(pointing satellite1 Star7)
	(have_image Planet12 spectrograph1)
	(have_image Planet12 infrared3)
	(have_image Star13 spectrograph2)
	(have_image Star13 infrared3)
	(have_image Phenomenon14 spectrograph1)
	(have_image Phenomenon14 spectrograph2)
	(have_image Phenomenon15 spectrograph1)
))

)
