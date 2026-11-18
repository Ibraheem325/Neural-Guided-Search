(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	instrument5 - instrument
	infrared0 - mode
	spectrograph4 - mode
	infrared2 - mode
	image3 - mode
	infrared1 - mode
	GroundStation5 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star0 - direction
	Star3 - direction
	Star1 - direction
	GroundStation6 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
	Star17 - direction
	Planet18 - direction
	Planet19 - direction
	Phenomenon20 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon13)
	(supports instrument1 infrared1)
	(supports instrument1 infrared0)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star0)
	(supports instrument2 infrared2)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation7)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet11)
	(supports instrument3 infrared0)
	(supports instrument3 image3)
	(supports instrument3 spectrograph4)
	(calibration_target instrument3 GroundStation6)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet15)
	(supports instrument4 infrared2)
	(supports instrument4 image3)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star1)
	(supports instrument5 spectrograph4)
	(supports instrument5 image3)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 GroundStation4)
	(on_board instrument4 satellite3)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon13)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(pointing satellite1 Phenomenon14)
	(have_image Phenomenon10 infrared1)
	(have_image Planet11 spectrograph4)
	(have_image Phenomenon12 infrared0)
	(have_image Phenomenon13 infrared0)
	(have_image Phenomenon14 spectrograph4)
	(have_image Planet15 infrared0)
	(have_image Planet16 spectrograph4)
	(have_image Star17 spectrograph4)
	(have_image Planet18 infrared1)
	(have_image Planet19 infrared0)
	(have_image Phenomenon20 infrared2)
))

)
